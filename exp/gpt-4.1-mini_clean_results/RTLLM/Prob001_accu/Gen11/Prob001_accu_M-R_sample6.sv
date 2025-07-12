module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // State encoding
    localparam IDLE       = 1'b0;
    localparam ACCUMULATE = 1'b1;

    reg state, next_state;
    reg [9:0] accumulator;
    reg [2:0] count;  // 3 bits to count up to 4

    // Next-state and output logic
    always @(*) begin
        // Defaults
        next_state = state;
        valid_out = 1'b0;
        data_out = 10'd0;

        case(state)
            IDLE: begin
                if (valid_in) begin
                    next_state = ACCUMULATE;
                end
            end
            ACCUMULATE: begin
                if (count == 3'd4) begin
                    valid_out = 1'b1;
                    data_out = accumulator;
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Sequential state and accumulator updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accumulator <= 10'd0;
            count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                if (valid_in) begin
                    accumulator <= data_in;
                    count <= 3'd1;
                end else begin
                    accumulator <= 10'd0;
                    count <= 3'd0;
                end
            end else if (state == ACCUMULATE) begin
                if (count < 3'd4) begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1;
                    end
                end else begin
                    accumulator <= 10'd0;
                    count <= 3'd0;
                end
            end
        end
    end

endmodule