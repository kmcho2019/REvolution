module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

reg [1:0] state; // Current state, using 2 bits for clarity and potential expansion
reg [1:0] count; // Counter to track the number of clock cycles in STATE_B
reg [1:0] ones; // Counter to track the number of '1's in the last three 'w' values

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        count <= 2'b00;
        ones <= 2'b00;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    count <= 2'b01;
                    ones <= w ? 2'b01 : 2'b00;
                    z <= 0;
                end
            end
            STATE_B: begin
                count <= count + 1;
                if(w) begin
                    ones <= ones + 1;
                end
                if(count == 2'b11) begin // Check after three clock cycles
                    if(ones == 2'b10) begin // Exactly two '1's in the window
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    count <= 2'b01; // Reset counter
                    ones <= w ? 2'b01 : 2'b00; // Reset 'ones' counter based on current 'w'
                end
            end
        endcase
    end
end

endmodule