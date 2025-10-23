module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        SHIFTING,
        UPDATING
    } state_t;
    
    reg [1:0] state;
    reg [8:0] counter;
    reg [511:0] next_q;
    reg [2:0] neighborhood;  // Stores left, center, right
    
    // Circular boundary implementation
    wire left_bound = q[0];
    wire right_bound = q[511];
    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (load) begin
                    q <= data;
                    state <= IDLE;
                end else begin
                    counter <= 0;
                    state <= SHIFTING;
                    neighborhood <= {q[1], q[0], right_bound};  // Initialize with first cell
                end
            end
            
            SHIFTING: begin
                // Shift in next neighborhood
                if (counter < 511) begin
                    neighborhood <= {q[counter+2], q[counter+1], q[counter]};
                    counter <= counter + 1;
                end else begin
                    state <= UPDATING;
                    counter <= 0;
                end
            end
            
            UPDATING: begin
                // Apply Rule 110 to current neighborhood
                case (neighborhood)
                    3'b111: next_q[counter] <= 1'b0;
                    3'b110: next_q[counter] <= 1'b1;
                    3'b101: next_q[counter] <= 1'b1;
                    3'b100: next_q[counter] <= 1'b0;
                    3'b011: next_q[counter] <= 1'b1;
                    3'b010: next_q[counter] <= 1'b1;
                    3'b001: next_q[counter] <= 1'b1;
                    3'b000: next_q[counter] <= 1'b0;
                endcase
                
                if (counter < 511) begin
                    counter <= counter + 1;
                    state <= SHIFTING;
                end else begin
                    q <= next_q;
                    state <= IDLE;
                end
            end
        endcase
    end

endmodule