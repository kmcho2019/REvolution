module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    wire [1:0] c_low = c[1:0];
    wire c_lt4 = (c < 4);

    // Concatenate inputs for clarity, though not directly shifted
    wire [3:0] inputs_mux [3:0];
    assign inputs_mux[0] = b;
    assign inputs_mux[1] = e;
    assign inputs_mux[2] = a;
    assign inputs_mux[3] = d;

    always @(*) begin
        if (c_lt4) begin
            case (c_low)
                2'd0: q = inputs_mux[0];
                2'd1: q = inputs_mux[1];
                2'd2: q = inputs_mux[2];
                2'd3: q = inputs_mux[3];
                default: q = 4'hF; // Should never occur as c_low is 2 bits
            endcase
        end else begin
            q = 4'hF;
        end
    end

endmodule