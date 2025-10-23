module TopModule (
    input clk,
    input d,
    output reg q
);

function reg dff_function;
    input din;
    begin
        dff_function = din;
    end
endfunction

always @(posedge clk) begin
    q <= dff_function(d);
end

endmodule