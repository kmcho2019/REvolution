module TopModule(input clk, input a, output q);
    wire a_inv;
    assign a_inv = ~a;
    
    DFF dff_inst (
        .clk(clk),
        .d(a_inv),
        .q(q)
    );
endmodule

// Basic D flip-flop module
module DFF(input clk, input d, output reg q);
    always @(posedge clk) begin
        q <= d;
    end
endmodule