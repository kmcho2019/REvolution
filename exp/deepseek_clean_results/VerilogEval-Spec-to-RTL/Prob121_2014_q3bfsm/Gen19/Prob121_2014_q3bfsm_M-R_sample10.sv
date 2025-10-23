module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding
    reg [4:0] current_state;  // S0-S4
    wire [4:0] next_state;

    // State transitions
    assign next_state[0] = (~reset) & ( // S0
        (~x & current_state[0]) |          // S0->S0
        (~x & current_state[1]) |          // S1->S1
        (x & current_state[3])             // S3->S1
    );

    assign next_state[1] = (~reset) & ( // S1
        (x & current_state[0]) |          // S0->S1
        (x & current_state[2]) |          // S2->S1
        (~x & current_state[3])           // S3->S1
    );

    assign next_state[2] = (~reset) & ( // S2
        (~x & current_state[2]) |          // S2->S2
        (x & current_state[3])            // S3->S2
    );

    assign next_state[3] = (~reset) & ( // S3
        (~x & current_state[4])           // S4->S3
    );

    assign next_state[4] = (~reset) & ( // S4
        (x & current_state[1]) |          // S1->S4
        (x & current_state[4])            // S4->S4
    );

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= 5'b00001;  // Reset to S0
        else
            current_state <= next_state;
    end

    // Output logic (S3 or S4)
    assign z = current_state[3] | current_state[4];

endmodule