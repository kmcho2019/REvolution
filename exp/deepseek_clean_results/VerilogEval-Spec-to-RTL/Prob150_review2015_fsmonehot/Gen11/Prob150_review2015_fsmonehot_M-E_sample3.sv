module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Parallel next-state predictors
    wire predict_S = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
    wire predict_S1 = state[0] & d;
    wire predict_S11 = state[1] & d;
    wire predict_S110 = state[2] & ~d;
    wire predict_B0 = state[3] & d;
    wire predict_B1 = state[4];
    wire predict_B2 = state[5];
    wire predict_B3 = state[6];
    wire predict_Count = state[7] | (state[8] & ~done_counting);
    wire predict_Wait = (state[8] & done_counting) | (state[9] & ~ack);

    // Priority-based next state selection
    assign S_next = predict_S;
    assign S1_next = predict_S1 & ~predict_S;
    assign B3_next = predict_B3 & ~(predict_S | predict_S1 | predict_S11 | predict_S110 | predict_B0 | predict_B1 | predict_B2);
    assign Count_next = predict_Count & ~(predict_S | predict_S1 | predict_S11 | predict_S110 | predict_B0 | predict_B1 | predict_B2 | predict_B3);
    assign Wait_next = predict_Wait & ~(predict_S | predict_S1 | predict_S11 | predict_S110 | predict_B0 | predict_B1 | predict_B2 | predict_B3 | predict_Count);

    // Parallel output pre-calculation
    wire [2:0] output_S = 3'b000;
    wire [2:0] output_S1 = 3'b000;
    wire [2:0] output_S11 = 3'b000;
    wire [2:0] output_S110 = 3'b000;
    wire [2:0] output_B0 = 3'b100;
    wire [2:0] output_B1 = 3'b100;
    wire [2:0] output_B2 = 3'b100;
    wire [2:0] output_B3 = 3'b100;
    wire [2:0] output_Count = 3'b010;
    wire [2:0] output_Wait = 3'b001;

    // Output multiplexing
    assign {shift_ena, counting, done} = 
        (state[0] ? output_S :
         state[1] ? output_S1 :
         state[2] ? output_S11 :
         state[3] ? output_S110 :
         state[4] ? output_B0 :
         state[5] ? output_B1 :
         state[6] ? output_B2 :
         state[7] ? output_B3 :
         state[8] ? output_Count :
         output_Wait);

endmodule