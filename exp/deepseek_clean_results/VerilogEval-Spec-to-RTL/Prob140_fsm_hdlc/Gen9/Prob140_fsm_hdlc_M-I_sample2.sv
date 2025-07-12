module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Gray-coded state encoding
    localparam S0 = 2'b00;  // Initial/zero state
    localparam S1 = 2'b01;  // 1 one
    localparam S2 = 2'b11;  // 2 ones
    localparam S3 = 2'b10;  // 3 ones
    localparam S4 = 2'b00;  // 4 ones (reuses S0 encoding)
    localparam S5 = 2'b01;  // 5 ones (reuses S1 encoding)
    
    reg [1:0] state, next_state;
    reg [1:0] ones_count;  // Tracks actual count of 1s

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            ones_count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            
            // Output generation (registered)
            disc <= (ones_count == 5) && !in;
            flag <= (ones_count == 6) && !in;
            err <= (ones_count >= 6) && in;
            
            // Update ones counter
            if (in) begin
                if (ones_count < 6) ones_count <= ones_count + 1;
            end else begin
                ones_count <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S5 : S0;  // Hold until zero
            default: next_state = S0;
        endcase
    end

endmodule