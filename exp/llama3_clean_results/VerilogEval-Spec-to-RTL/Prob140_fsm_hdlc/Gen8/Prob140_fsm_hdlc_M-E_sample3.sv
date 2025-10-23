module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state; // High-level state
reg [2:0] ones_count; // Counter for consecutive ones

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        ones_count <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in) begin
                    state <= 1; // SEQUENCE
                    ones_count <= 1;
                end
            end
            1: begin // SEQUENCE
                if (in) begin
                    ones_count <= ones_count + 1;
                    if (ones_count == 5) begin
                        state <= 2; // Potential flag or discard
                    end else if (ones_count >= 7) begin
                        state <= 3; // ERROR
                    end
                end else begin
                    if (ones_count == 6) begin
                        flag <= 1; // Flag detected
                    end else if (ones_count == 5) begin
                        disc <= 1; // Discard bit
                    end
                    state <= 0; // IDLE
                    ones_count <= 0;
                end
            end
            2: begin // Potential flag or discard
                if (~in) begin
                    flag <= 1; // Flag detected
                    state <= 0; // IDLE
                    ones_count <= 0;
                end else begin
                    ones_count <= ones_count + 1;
                    if (ones_count >= 7) begin
                        state <= 3; // ERROR
                    end
                end
            end
            3: begin // ERROR
                err <= 1; // Error detected
                if (~in) begin
                    state <= 0; // IDLE
                    ones_count <= 0;
                    err <= 0;
                end
            end
            default: begin
                state <= 0; // IDLE
                ones_count <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    disc <= 0;
    flag <= 0;
end

endmodule