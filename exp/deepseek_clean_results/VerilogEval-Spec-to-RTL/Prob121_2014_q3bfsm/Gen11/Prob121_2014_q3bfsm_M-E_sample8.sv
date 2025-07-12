module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    localparam [2:0] S0 = 3'b000,
                     S1 = 3'b001,
                     S2 = 3'b010,
                     S3 = 3'b011,
                     S4 = 3'b100;

    reg [2:0] state, next_state;

    // Binary decision tree for next state logic
    always @(*) begin
        if (state[2]) begin           // State S4 (100)
            next_state = x ? S4 : S3;
        end else if (state[1]) begin  // States S2/S3 (010/011)
            if (state[0]) begin       // S3 (011)
                next_state = x ? S2 : S1;
            end else begin            // S2 (010)
                next_state = x ? S1 : S2;
            end
        end else if (state[0]) begin  // State S1 (001)
            next_state = x ? S4 : S1;
        end else begin               // State S0 (000)
            next_state = x ? S1 : S0;
        end
    end

    // Output logic - simple pattern matching
    assign z = (state == S3) || (state == S4);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule