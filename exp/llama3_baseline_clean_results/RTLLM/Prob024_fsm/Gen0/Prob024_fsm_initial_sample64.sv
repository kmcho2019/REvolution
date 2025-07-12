module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter Idle = 4'b0000,
          S1   = 4'b0001,
          S2   = 4'b0010,
          S3   = 4'b0011,
          S4   = 4'b0100,
          S5   = 4'b0101;

reg [3:0] current_state;
reg [3:0] next_state;

// Output signal
assign MATCH = (current_state == S5 && IN == 1) ? 1'b1 : 1'b0;

// State transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= Idle;
    end else begin
        case (current_state)
            Idle: begin
                if (IN == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= Idle;
                end
            end
            S1: begin
                if (IN == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= S1;
                end
            end
            S2: begin
                if (IN == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= S1;
                end
            end
            S3: begin
                if (IN == 1'b1) begin
                    current_state <= S4;
                end else begin
                    current_state <= S1;
                end
            end
            S4: begin
                if (IN == 1'b1) begin
                    current_state <= S5;
                end else begin
                    current_state <= S1;
                end
            end
            S5: begin
                current_state <= S1; // Reset to S1 after achieving the sequence
            end
            default: current_state <= Idle;
        endcase
    end
end

endmodule