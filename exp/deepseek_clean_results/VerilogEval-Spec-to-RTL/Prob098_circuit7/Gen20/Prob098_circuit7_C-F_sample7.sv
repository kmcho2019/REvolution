module DFF(input clk, input d, output reg q);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule(input clk, input a, output q);
    // Direct connection with inversion for minimal power and area
    DFF u_dff(.clk(clk), .d(~a), .q(q));
endmodule