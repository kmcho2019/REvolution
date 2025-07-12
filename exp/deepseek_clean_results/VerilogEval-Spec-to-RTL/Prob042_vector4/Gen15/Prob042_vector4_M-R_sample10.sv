// Alternative 1: Using always block
module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = {{24{in[7]}}, in};
    end
endmodule

// Alternative 2: Using function
module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    function [31:0] sign_extend;
        input [7:0] data;
        begin
            sign_extend = {{24{data[7]}}, data};
        end
    endfunction
    
    assign out = sign_extend(in);
endmodule