module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Recursive function to build binary tree mux
    function automatic logic mux_tree(input [255:0] data, input [7:0] select);
        if (select == 8'd0) begin
            return data[0];
        end
        else begin
            logic upper, lower;
            upper = mux_tree(data, {1'b0, select[6:0]});
            lower = mux_tree(data, {1'b1, select[6:0]});
            return select[7] ? lower : upper;
        end
    endfunction

    assign out = mux_tree(in, sel);

endmodule