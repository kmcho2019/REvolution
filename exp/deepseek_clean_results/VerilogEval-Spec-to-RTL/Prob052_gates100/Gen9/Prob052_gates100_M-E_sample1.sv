module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Reusable tree module for any bitwise reduction operation
    module reduction_tree #(
        parameter WIDTH = 100,
        parameter OP = "AND"  // "AND", "OR", or "XOR"
    ) (
        input [WIDTH-1:0] data,
        output result
    );
        localparam CHUNK_SIZE = 5;
        
        if (WIDTH <= CHUNK_SIZE) begin
            // Base case
            case (OP)
                "AND": assign result = &data;
                "OR":  assign result = |data;
                "XOR": assign result = ^data;
            endcase
        end
        else begin
            // Recursive case
            localparam NUM_CHUNKS = (WIDTH + CHUNK_SIZE - 1) / CHUNK_SIZE;
            wire [NUM_CHUNKS-1:0] chunk_results;
            
            for (genvar i = 0; i < NUM_CHUNKS; i++) begin
                localparam UPPER = (i+1)*CHUNK_SIZE > WIDTH ? WIDTH : (i+1)*CHUNK_SIZE;
                reduction_tree #(
                    .WIDTH(UPPER - i*CHUNK_SIZE),
                    .OP(OP)
                ) chunk (
                    .data(data[UPPER-1 : i*CHUNK_SIZE]),
                    .result(chunk_results[i])
                );
            end
            
            reduction_tree #(
                .WIDTH(NUM_CHUNKS),
                .OP(OP)
            ) final_stage (
                .data(chunk_results),
                .result(result)
            );
        end
    endmodule

    // Instantiate trees for each operation
    reduction_tree #(.OP("AND")) and_tree (.data(in), .result(out_and));
    reduction_tree #(.OP("OR"))  or_tree  (.data(in), .result(out_or));
    reduction_tree #(.OP("XOR")) xor_tree (.data(in), .result(out_xor));

endmodule