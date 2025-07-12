module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Binary encoded states
    localparam [2:0] STATE_0    = 3'b000;  // Initial state (prev input 0)
    localparam [2:0] STATE_1    = 3'b001;  // 1
    localparam [2:0] STATE_2    = 3'b010;  // 11
    localparam [2:0] STATE_3    = 3'b011;  // 111
    localparam [2:0] STATE_4    = 3'b100;  // 1111
    localparam [2:0] STATE_5    = 3'b101;  // 11111
    localparam [2:0] STATE_DISC = 3'b110;  // 111110 (discard next bit)
    localparam [2:0] STATE_ERR  = 3'b111;  // 1111111... (error)

    reg [2:0] state;
    reg next_disc, next_flag, next_err;

    // Continuous assignments for outputs
    assign disc = next_disc;
    assign flag = next_flag;
    assign err = next_err;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_0;
            {next_disc, next_flag, next_err} <= 3'b000;
        end else begin
            // Default outputs
            {next_disc, next_flag, next_err} <= 3'b000;

            // State transitions and output generation
            case (state)
                STATE_0: begin
                    state <= in ? STATE_1 : STATE_0;
                end
                STATE_1: begin
                    state <= in ? STATE_2 : STATE_0;
                end
                STATE_2: begin
                    state <= in ? STATE_3 : STATE_0;
                end
                STATE_3: begin
                    state <= in ? STATE_4 : STATE_0;
                end
                STATE_4: begin
                    state <= in ? STATE_5 : STATE_0;
                end
                STATE_5: begin
                    if (in) begin
                        state <= STATE_ERR;
                        next_err <= 1'b1;
                    end else begin
                        state <= STATE_DISC;
                        next_flag <= 1'b1;
                    end
                end
                STATE_DISC: begin
                    state <= in ? STATE_1 : STATE_0;
                    next_disc <= 1'b1;
                end
                STATE_ERR: begin
                    state <= in ? STATE_ERR : STATE_0;
                    next_err <= in;
                end
                default: begin
                    state <= STATE_0;
                end
            endcase
        end
    end

endmodule