module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
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
        end else begin
            case (current_state)
                IDLE:  current_state <= data ? S1 : IDLE;
                S1:    current_state <= data ? S2 : IDLE;
                S2:    current_state <= data ? S2 : S3;
                S3:    current_state <= data ? FOUND : IDLE;
                FOUND: current_state <= FOUND;
            endcase
        end
    end

    // Output is simply the MSB of the state register
    assign start_shifting = current_state[4];

endmodule