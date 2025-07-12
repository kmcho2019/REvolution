module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding with one-hot for better FPGA synthesis
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            done  <= (state == BYTE3);  // done asserted the cycle after third byte received
        end
    end

endmodule