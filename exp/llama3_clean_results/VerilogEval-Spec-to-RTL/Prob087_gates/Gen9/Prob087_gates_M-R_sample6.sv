// Define functions for each gate type
function logic ANDGate(logic a, logic b);
    ANDGate = a && b;
endfunction

function logic ORGate(logic a, logic b);
    ORGate = a || b;
endfunction

function logic XORGate(logic a, logic b);
    XORGate = a ^ b;
endfunction

function logic NANDGate(logic a, logic b);
    NANDGate = ~(a && b);
endfunction

function logic NORGate(logic a, logic b);
    NORGate = ~(a || b);
endfunction

function logic XNORGate(logic a, logic b);
    XNORGate = ~(a ^ b);
endfunction

function logic ANDNOTGate(logic a, logic b);
    ANDNOTGate = a && ~b;
endfunction

// TopModule uses the gate functions
module TopModule(
    input logic a,
    input logic b,
    output logic out_and,
    output logic out_or,
    output logic out_xor,
    output logic out_nand,
    output logic out_nor,
    output logic out_xnor,
    output logic out_anotb
);

    // Use the gate functions to assign outputs
    assign out_and = ANDGate(a, b);
    assign out_or = ORGate(a, b);
    assign out_xor = XORGate(a, b);
    assign out_nand = NANDGate(a, b);
    assign out_nor = NORGate(a, b);
    assign out_xnor = XNORGate(a, b);
    assign out_anotb = ANDNOTGate(a, b);

endmodule