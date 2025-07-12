module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam [3:0] NO_GRANT  = 4'b0001,  // State A
                     GRANT0    = 4'b0010,  // State B
                     GRANT1    = 4'b0100,  // State C
                     GRANT2    = 4'b1000;  // State D

    reg [3:0] state, next_state;
    
    // Next state logic
    always @(*) begin
        next_state = NO_GRANT;  // Default
        case (1'b1)  // Synopsys parallel_case
            state[0]: begin  // NO_GRANT
                casez (r)
                    3'b1??: next_state = GRANT0;
                    3'b01?: next_state = GRANT1;
                    3'b001: next_state = GRANT2;
                    default: next_state = NO_GRANT;
                endcase
            end
            state[1]: next_state = r[0] ? GRANT0 : NO_GRANT;  // GRANT0
            state[2]: next_state = r[1] ? GRANT1 : NO_GRANT;  // GRANT1
            state[3]: next_state = r[2] ? GRANT2 : NO_GRANT;  // GRANT2
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= NO_GRANT;
        end else begin
            state <= next_state;
        end
    end

    // Registered output logic
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 3'b000;
        end else begin
            g[0] <= (next_state == GRANT0);
            g[1] <= (next_state == GRANT1);
            g[2] <= (next_state == GRANT2);
        end
    end

endmodule