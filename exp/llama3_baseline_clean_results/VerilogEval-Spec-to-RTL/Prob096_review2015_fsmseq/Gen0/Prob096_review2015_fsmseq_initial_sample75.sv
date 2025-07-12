module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
localparam IDLE = 4'b0000;
localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0011;
localparam FOUND = 4'b0100;

// Current state
reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        // Reset the state and output
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    // Move to S1 if '1' is found
                    state <= S1;
                end
            end
            S1: begin
                if (data) begin
                    // Move to S2 if next '1' is found
                    state <= S2;
                end else begin
                    // Reset to IDLE if '0' is found
                    state <= IDLE;
                end
            end
            S2: begin
                if (!data) begin
                    // Move to S3 if '0' is found
                    state <= S3;
                end else begin
                    // Reset to S1 if '1' is found
                    state <= S1;
                end
            end
            S3: begin
                if (data) begin
                    // Move to FOUND if '1' is found
                    state <= FOUND;
                end else begin
                    // Reset to IDLE if '0' is found
                    state <= IDLE;
                end
            end
            FOUND: begin
                // Stay in FOUND forever until reset
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule