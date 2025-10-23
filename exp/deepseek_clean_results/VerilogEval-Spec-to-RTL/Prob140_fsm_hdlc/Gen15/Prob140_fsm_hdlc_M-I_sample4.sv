module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    parameter [7:0] S0 = 8'b00000001,
                   S1 = 8'b00000010,
                   S2 = 8'b00000100,
                   S3 = 8'b00001000,
                   S4 = 8'b00010000,
                   S5 = 8'b00100000,
                   S6 = 8'b01000000,
                   S7 = 8'b10000000;

    reg [7:0] state;
    reg error_latched;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
            error_latched <= 0;
        end else begin
            // Clear outputs unless set below
            disc <= 0;
            flag <= 0;
            
            if (error_latched) begin
                err <= 1;
            end else begin
                err <= 0;
            end

            if (in && !error_latched) begin
                case (state)
                    S0: state <= S1;
                    S1: state <= S2;
                    S2: state <= S3;
                    S3: state <= S4;
                    S4: state <= S5;
                    S5: state <= S6;
                    S6: begin
                        state <= S7;
                        flag <= 1;
                    end
                    S7: begin
                        err <= 1;
                        error_latched <= 1;
                    end
                endcase
            end else begin
                // Check for disc and flag conditions on 0 input
                if (state == S5) disc <= 1;
                if (state == S6 && !in) flag <= 1;
                
                // Reset state unless in error condition
                if (!error_latched) state <= S0;
            end
        end
    end

endmodule