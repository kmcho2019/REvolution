module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Recursive module for binary tree mux
    module mux_tree #(
        parameter LEVEL = 0,
        parameter WIDTH = 1024
    ) (
        input  [WIDTH-1:0] in,
        input  [7:0]       sel,
        output [3:0]       out
    );
        if (LEVEL == 8) begin
            // Base case - select the final 4 bits
            assign out = in[3:0];
        end else begin
            // Recursive case - split input into two halves and mux between them
            wire [3:0] out_0, out_1;
            
            mux_tree #(
                .LEVEL(LEVEL + 1),
                .WIDTH(WIDTH / 2)
            ) mux0 (
                .in(in[0 +: WIDTH/2]),
                .sel(sel),
                .out(out_0)
            );
            
            mux_tree #(
                .LEVEL(LEVEL + 1),
                .WIDTH(WIDTH / 2)
            ) mux1 (
                .in(in[WIDTH/2 +: WIDTH/2]),
                .sel(sel),
                .out(out_1)
            );
            
            // Select between the two halves based on current level's sel bit
            assign out = sel[LEVEL] ? out_1 : out_0;
        end
    endmodule
    
    // Instantiate the root of the mux tree
    mux_tree mux (
        .in(in),
        .sel(sel),
        .out(out)
    );
endmodule