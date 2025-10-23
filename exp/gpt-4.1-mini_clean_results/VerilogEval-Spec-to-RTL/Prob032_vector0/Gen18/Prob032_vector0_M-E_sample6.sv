module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Define a packed struct type with named bits
    typedef struct packed {
        logic o0;
        logic o1;
        logic o2;
    } bit_fields_t;

    // Use a reg of the struct type to overlay the vector bits
    bit_fields_t bits;

    // Assign the input vector to the packed struct
    always @(*) begin
        bits = vec;
    end

    // Connect outputs from the struct fields
    assign o0 = bits.o0;
    assign o1 = bits.o1;
    assign o2 = bits.o2;

    // Assign output vector directly from the struct representation
    assign outv = bits;

endmodule