module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    wire c_lt4 = (c < 4);

    // Pack inputs b, e, a, d in order for easy indexing by c[1:0]
    wire [15:0] vec = {d, a, e, b};

    wire [1:0] c_idx = c[1:0];

    // Select one 4-bit segment from vec based on c_idx
    reg [3:0] selected;
    always @(*) begin
        case (c_idx)
            2'd0: selected = vec[3:0];    // b
            2'd1: selected = vec[7:4];    // e
            2'd2: selected = vec[11:8];   // a
            2'd3: selected = vec[15:12];  // d
            default: selected = 4'hF;     // Should not occur
        endcase
    end

    assign q = c_lt4 ? selected : 4'hF;

endmodule