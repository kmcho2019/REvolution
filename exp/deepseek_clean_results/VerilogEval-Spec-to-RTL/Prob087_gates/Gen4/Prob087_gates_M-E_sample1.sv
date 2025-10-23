module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Define a packed struct for all outputs
    typedef struct packed {
        logic anotb;
        logic xnor;
        logic nor;
        logic nand;
        logic xor;
        logic or;
        logic and;
    } gate_outputs;

    // Create the LUT with all possible input combinations
    gate_outputs [3:0] lut = '{
        '{anotb: 0, xnor: 1, nor: 1, nand: 1, xor: 0, or: 0, and: 0},  // 00
        '{anotb: 0, xnor: 0, nor: 0, nand: 1, xor: 1, or: 1, and: 0},  // 01
        '{anotb: 1, xnor: 0, nor: 0, nand: 1, xor: 1, or: 1, and: 0},  // 10
        '{anotb: 0, xnor: 1, nor: 0, nand: 0, xor: 0, or: 1, and: 1}   // 11
    };

    // Index into the LUT based on input combination
    wire [1:0] index = {a, b};
    gate_outputs outputs = lut[index];

    // Assign outputs
    assign out_and = outputs.and;
    assign out_or = outputs.or;
    assign out_xor = outputs.xor;
    assign out_nand = outputs.nand;
    assign out_nor = outputs.nor;
    assign out_xnor = outputs.xnor;
    assign out_anotb = outputs.anotb;

endmodule