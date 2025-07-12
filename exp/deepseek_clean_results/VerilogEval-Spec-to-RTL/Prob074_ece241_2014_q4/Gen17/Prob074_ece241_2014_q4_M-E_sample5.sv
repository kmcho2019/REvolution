module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] phase = 0;  // 0-3 counter for operation phases
    reg [2:0] storage = 0; // Stores XOR/AND/OR results
    reg feedback = 0;      // Shared feedback register
    
    always @(posedge clk) begin
        case (phase)
            0: begin // XOR phase
                feedback <= x ^ feedback;
                storage[0] <= feedback;
                phase <= 1;
            end
            1: begin // AND phase
                feedback <= x & ~feedback;
                storage[1] <= feedback;
                phase <= 2;
            end
            2: begin // OR phase
                feedback <= x | ~feedback;
                storage[2] <= feedback;
                phase <= 3;
            end
            3: begin // NOR output phase
                z <= ~(|storage);
                phase <= 0;
            end
        endcase
    end

endmodule