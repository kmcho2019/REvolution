module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [4:0] state;  // States: 00001, 00010, 00100, 01000, 10000

    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001;
        else begin
            case (state)
                5'b00001: state <= x ? 5'b00010 : 5'b00001;  // State 000
                5'b00010: state <= x ? 5'b10000 : 5'b00010;  // State 001
                5'b00100: state <= x ? 5'b00010 : 5'b00100;  // State 010
                5'b01000: state <= x ? 5'b00100 : 5'b00010;  // State 011
                5'b10000: state <= x ? 5'b10000 : 5'b01000;  // State 100
                default: state <= 5'b00001;
            endcase
        end
    end

    assign z = (state[3] | state[4]);  // States 011 (01000) and 100 (10000)

endmodule