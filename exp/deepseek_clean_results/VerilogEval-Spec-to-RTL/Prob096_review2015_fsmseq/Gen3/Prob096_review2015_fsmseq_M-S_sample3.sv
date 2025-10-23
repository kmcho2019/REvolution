module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else case (state)
            3'b000: state <= data ? 3'b001 : 3'b000;  // IDLE
            3'b001: state <= data ? 3'b010 : 3'b000;  // GOT1
            3'b010: state <= data ? 3'b010 : 3'b011;  // GOT11
            3'b011: state <= data ? 3'b100 : 3'b000;  // GOT110
            3'b100: state <= 3'b100;                 // FOUND
        endcase
    end

    assign start_shifting = (state == 3'b100);

endmodule