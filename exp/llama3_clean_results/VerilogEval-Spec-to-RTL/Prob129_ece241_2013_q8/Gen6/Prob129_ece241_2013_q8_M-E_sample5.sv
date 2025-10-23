module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg       prev_x;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state  <= 2'b00;
        prev_x <= 1'b0;
    end else begin
        prev_x <= x;
        case (state)
            2'b00: if (x == 1'b1 && prev_x == 1'b0) state <= 2'b01; 
                    else state <= 2'b00;
            2'b01: if (x == 1'b1) state <= 2'b10; 
                    else state <= 2'b00;
            2'b10: if (x == 1'b1) state <= 2'b10; 
                    else state <= 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
assign z = (state == 2'b10);

endmodule