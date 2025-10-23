module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] count;
reg prev_x;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        count <= 2'b00;
        prev_x <= 1'b0;
    end else begin
        if (x && !prev_x) begin
            count <= count + 1'b1;
        end else if (!x && prev_x) begin
            count <= count + 1'b1;
        end
        prev_x <= x;
    end
end

// Output logic
assign z = (count == 2'b10 && x);

endmodule