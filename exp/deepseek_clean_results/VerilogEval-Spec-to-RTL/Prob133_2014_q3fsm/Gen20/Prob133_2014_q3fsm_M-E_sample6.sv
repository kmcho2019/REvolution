module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding with next state condition
    reg [1:0] state;
    localparam A      = 2'b00;  // Reset state
    localparam B_WAIT = 2'b01;  // First cycle in B
    localparam B_RUN  = 2'b10;  // Subsequent cycles in B

    // Shift register for last 3 w values
    reg [2:0] w_history;

    // Combinational logic for counting 1's in history
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];

    // Output logic (registered to meet timing)
    reg z_reg;
    assign z = z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            z_reg <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B_WAIT;
                        w_history <= {2'b00, w};  // Initialize with current w
                    end
                    z_reg <= 1'b0;
                end
                
                B_WAIT: begin
                    state <= B_RUN;
                    w_history <= {w_history[1:0], w};  // Shift in next w
                    z_reg <= 1'b0;
                end
                
                B_RUN: begin
                    w_history <= {w_history[1:0], w};  // Continue shifting
                    
                    // Output is true when window is full and exactly two 1's
                    z_reg <= (ones_count == 2'd2);
                end
            endcase
        end
    end

endmodule