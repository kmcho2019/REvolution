module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter to track consecutive ones
reg prev_in; // Flag to indicate the previous input

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        prev_in <= 0;
    end else begin
        if (in) begin
            count <= count + 1;
        end else begin
            count <= 0;
        end
        prev_in <= in;
    end
end

assign disc = (count == 5) &&!in;
assign flag = (count == 6) &&!in;
assign err = (count >= 7);

endmodule