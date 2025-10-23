module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding for better timing
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Combinational outputs
    assign done = (state == STOP) & in;

    // Next state logic (combinational)
    wire [3:0] next_state;
    assign next_state = 
        reset ? IDLE :
        (state == IDLE)    ? (in == 0 ? RECEIVE : IDLE) :
        (state == RECEIVE) ? (bit_count == 3'd7 ? STOP : RECEIVE) :
        (state == STOP)    ? (in == 1 ? IDLE : ERROR) :
        (state == ERROR)   ? (in == 1 ? IDLE : ERROR) :
        IDLE;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin
                        data_reg <= 0;
                    end
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in) begin
                        out_byte <= data_reg;
                    end
                end

                ERROR: begin
                    // Wait for stop bit
                end
            endcase
        end
    end

endmodule