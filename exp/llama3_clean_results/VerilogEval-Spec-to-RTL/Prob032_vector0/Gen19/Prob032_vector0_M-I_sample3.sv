module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
    );

    // Direct assignment for performance and power efficiency
    assign outv = vec;
    // Individual bit assignments maintained for clarity and minimalism
    assign o2   = vec[2];
    assign o1   = vec[1];
    assign o0   = vec[0];

    // No additional logic or complexity introduced to maintain low PPA metrics
endmodule