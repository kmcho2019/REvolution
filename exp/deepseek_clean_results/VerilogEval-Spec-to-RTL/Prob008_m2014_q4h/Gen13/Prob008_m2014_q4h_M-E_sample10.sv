module TopModule (
    input in,
    output out
);
    // Behavioral model of a transmission gate
    // n_en and p_en are always on in this case
    wire n_en = 1'b1;
    wire p_en = 1'b1;
    
    // Transmission gate behavior
    assign out = (n_en & p_en) ? in : 1'bz;
endmodule