module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam [4:0] 
        IDLE  = 5'b00001,
        S1    = 5'b00010,
        S2    = 5'b00100,
        S3    = 5'b01000,
        FOUND = 5'b10000;

    reg [4:0] current_state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    current_state <= data ? S1 : IDLE;
                    start_shifting <= 1'b0;
                end
                S1: begin
                    current_state <= data ? S2 : IDLE;
                    start_shifting <= 1'b0;
                end
                S2: begin
                    current_state <= data ? S2 : S3;
                    start_shifting <= 1'b0;
                end
                S3: begin
                    current_state <= data ? FOUND : IDLE;
                    start_shifting <= data;
                end
                FOUND: begin
                    current_state <= FOUND;
                    start_shifting <= 1'b1;
                end
            endcase
        end
    end

endmodule