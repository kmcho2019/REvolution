module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: if (x) state <= 2'b01; 
            2'b01: if (!x) state <= 2'b10; else state <= 2'b01;
            2'b10: if (x) state <= 2'b00; else state <= 2'b10;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
assign z = (state == 2'b10 && x == 1'b1);

endmodule