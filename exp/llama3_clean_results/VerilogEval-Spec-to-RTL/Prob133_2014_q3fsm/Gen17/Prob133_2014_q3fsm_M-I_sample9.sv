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

reg state; // Current state
reg [1:0] counter; // Counter to track the number of clock cycles since entering state B
reg [2:0] w_count; // Counter to track the number of '1's in the last three 'w' values

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        counter <= 2'b00;
        w_count <= 3'b000;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    counter <= 2'b01;
                    w_count <= w? 3'b001 : 3'b000;
                end
                z <= 0;
            end
            STATE_B: begin
                // Shift in the current value of 'w'
                w_count <= {w_count[1:0], w};
                // Increment the counter
                counter <= counter + 1'b1;
                // Check if we have reached the end of the three clock cycles
                if(counter == 2'b11) begin
                    // Check if exactly two of the last three 'w' values are '1'
                    if(w_count == 3'b110 || w_count == 3'b101 || w_count == 3'b011) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    // Reset the counter
                    counter <= 2'b01;
                    w_count <= w? 3'b001 : 3'b000;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule