module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Recursive function to implement binary tree mux
    function automatic bit mux_tree;
        input [255:0] data;
        input [7:0] select;
        integer level;
        begin
            if ($bits(data) == 1) begin
                mux_tree = data;
            end
            else begin
                // Split into upper and lower halves
                integer half_size = $bits(data) / 2;
                bit [half_size-1:0] upper = data[$bits(data)-1 : half_size];
                bit [half_size-1:0] lower = data[half_size-1 : 0];
                
                // Use current selector bit to choose half
                mux_tree = select[$clog2($bits(data))-1] ? 
                          mux_tree(upper, select) : 
                          mux_tree(lower, select);
            end
        end
    endfunction

    assign out = mux_tree(in, sel);

endmodule