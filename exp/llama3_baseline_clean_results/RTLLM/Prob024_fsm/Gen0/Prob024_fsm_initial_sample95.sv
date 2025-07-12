module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter IDLE = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;

// State register
reg [3:0] current_state;
reg [3:0] next_state;

// Output signal
reg MATCH_reg;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH_reg <= 0;
    end
    else begin
        case (current_state)
            IDLE: begin
                if (IN) begin
                    current_state <= S1;
                end
                else begin
                    current_state <= IDLE;
                end
                MATCH_reg <= 0;
            end
            S1: begin
                if (!IN) begin
                    current_state <= S2;
                end
                else begin
                    current_state <= S1;
                end
                MATCH_reg <= 0;
            end
            S2: begin
                if (!IN) begin
                    current_state <= S3;
                end
                else begin
                    current_state <= S1;
                end
                MATCH_reg <= 0;
            end
            S3: begin
                if (IN) begin
                    current_state <= S4;
                end
                else begin
                    current_state <= IDLE;
                end
                MATCH_reg <= 0;
            end
            S4: begin
                if (IN) begin
                    current_state <= S5;
                end
                else begin
                    current_state <= IDLE;
                end
                MATCH_reg <= 0;
            end
            S5: begin
                if (IN) begin
                    current_state <= S5;
                    MATCH_reg <= 1;
                end
                else begin
                    current_state <= IDLE;
                    MATCH_reg <= 0;
                end
            end
            default: begin
                current_state <= IDLE;
                MATCH_reg <= 0;
            end
        endcase
    end
end

// Output assignment
assign MATCH = MATCH_reg;

endmodule