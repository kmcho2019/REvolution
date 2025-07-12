module TopModule (
    input d,
    input done_counting,
    input ack,
    input [3:0] state,  // Binary encoding: S(0), S1(1), S11(2), S110(3),
                         // B0(4), B1(5), B2(6), B3(7), Count(8), Wait(9)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State definitions
    localparam S     = 4'd0;
    localparam S1    = 4'd1;
    localparam S11   = 4'd2;
    localparam S110  = 4'd3;
    localparam B0    = 4'd4;
    localparam B1    = 4'd5;
    localparam B2    = 4'd6;
    localparam B3    = 4'd7;
    localparam Count = 4'd8;
    localparam Wait  = 4'd9;

    // Next state logic
    assign S_next = ((state == S || state == S1 || state == S110) && !d) || 
                   (state == Wait && ack);
    assign S1_next = (state == S && d);
    assign B3_next = (state == B2);
    assign Count_next = (state == B3) || (state == Count && !done_counting);
    assign Wait_next = (state == Count && done_counting) || 
                      (state == Wait && !ack);

    // Output logic
    assign shift_ena = (state >= B0 && state <= B3);
    assign counting = (state == Count);
    assign done = (state == Wait);

endmodule