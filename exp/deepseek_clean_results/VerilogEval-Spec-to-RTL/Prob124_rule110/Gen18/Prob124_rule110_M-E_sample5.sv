module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // State machine states
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam COMPUTE = 2'b10;
    
    reg [1:0] state;
    reg [8:0] counter;  // 9-bit counter for 512 positions
    reg [2:0] window;   // 3-bit window (left, center, right)
    reg [511:0] next_q;
    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (load) begin
                    state <= LOAD;
                    counter <= 0;
                end else begin
                    state <= COMPUTE;
                    counter <= 0;
                    // Initialize window with boundary conditions
                    window <= {q[0], q[511], 1'b0};  // q[-1] is 0
                end
            end
            
            LOAD: begin
                q <= data;
                state <= IDLE;
            end
            
            COMPUTE: begin
                // Compute next state for current position
                case (window)
                    3'b111: next_q[counter] <= 1'b0;
                    3'b110: next_q[counter] <= 1'b1;
                    3'b101: next_q[counter] <= 1'b1;
                    3'b100: next_q[counter] <= 1'b0;
                    3'b011: next_q[counter] <= 1'b1;
                    3'b010: next_q[counter] <= 1'b1;
                    3'b001: next_q[counter] <= 1'b1;
                    3'b000: next_q[counter] <= 1'b0;
                endcase
                
                // Shift window for next position
                if (counter == 511) begin
                    // Wrap around for circular boundary
                    window <= {q[511], q[0], q[510]};
                    state <= IDLE;
                    q <= next_q;
                end else if (counter == 510) begin
                    // Handle second-to-last position (right boundary is 0)
                    window <= {q[510], q[511], 1'b0};
                    counter <= counter + 1;
                end else begin
                    // Normal case
                    window <= {q[counter], q[counter+1], q[counter+2]};
                    counter <= counter + 1;
                end
            end
        endcase
    end

endmodule