module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // 3-bit state register
reg       seq_det; // Sequence detection flag
reg [2:0] counter; // 3-bit counter

// Define states
localparam IDLE = 3'b000;
localparam S1   = 3'b001;
localparam S2   = 3'b010;
localparam S3   = 3'b011;
localparam S4   = 3'b100;
localparam MATCH_STATE = 3'b101;

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= IDLE; // Reset state
        seq_det <= 1'b0; // Reset sequence detection flag
        counter <= 3'b000; // Reset counter
    end else begin
        case(state)
            IDLE: begin
                if(IN) begin
                    state <= S1; // Transition to S1
                    counter <= 3'b001; // Increment counter
                end else begin
                    state <= IDLE; // Stay in IDLE
                end
            end
            S1: begin
                if(!IN) begin
                    state <= S2; // Transition to S2
                    counter <= 3'b010; // Increment counter
                end else begin
                    state <= IDLE; // Reset to IDLE
                    counter <= 3'b000; // Reset counter
                end
            end
            S2: begin
                if(!IN) begin
                    state <= S3; // Transition to S3
                    counter <= 3'b011; // Increment counter
                end else begin
                    state <= IDLE; // Reset to IDLE
                    counter <= 3'b000; // Reset counter
                end
            end
            S3: begin
                if(IN) begin
                    state <= S4; // Transition to S4
                    counter <= 3'b100; // Increment counter
                end else begin
                    state <= IDLE; // Reset to IDLE
                    counter <= 3'b000; // Reset counter
                end
            end
            S4: begin
                if(IN) begin
                    state <= MATCH_STATE; // Transition to MATCH
                    seq_det <= 1'b1; // Set sequence detection flag
                end else begin
                    state <= IDLE; // Reset to IDLE
                    counter <= 3'b000; // Reset counter
                end
            end
            MATCH_STATE: begin
                state <= IDLE; // Reset to IDLE
                counter <= 3'b000; // Reset counter
            end
        endcase
    end
end

assign MATCH = (state == MATCH_STATE) ? 1'b1 : 1'b0;

endmodule