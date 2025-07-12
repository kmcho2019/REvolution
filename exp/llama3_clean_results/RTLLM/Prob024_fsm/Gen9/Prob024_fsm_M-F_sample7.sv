module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// One-hot encoding for states
reg [4:0] current_state;

// Initialize state to idle (00000)
initial current_state = 5'b00000;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        case (current_state)
            5'b00000: begin
                if (IN) begin
                    current_state <= 5'b00001;
                end
            end
            5'b00001: begin
                if (!IN) begin
                    current_state <= 5'b00010;
                end else begin
                    current_state <= 5'b00000;
                end
            end
            5'b00010: begin
                if (!IN) begin
                    current_state <= 5'b00100;
                end else begin
                    current_state <= 5'b00000;
                end
            end
            5'b00100: begin
                if (IN) begin
                    current_state <= 5'b01000;
                end else begin
                    current_state <= 5'b00000;
                end
            end
            5'b01000: begin
                if (IN) begin
                    MATCH <= 1'b1;
                    // Stay in the same state if input is 1
                    current_state <= 5'b01000;
                end else begin
                    current_state <= 5'b00000;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                current_state <= 5'b00000;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule