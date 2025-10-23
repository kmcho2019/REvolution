module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    localparam A = 1'b0;
    localparam B = 1'b1;
    reg state;

    // Window counter definitions
    localparam CYCLE_0 = 2'b00;
    localparam CYCLE_1 = 2'b01;
    localparam CYCLE_2 = 2'b10;
    
    reg [1:0] cycle_count;
    reg [2:0] w_history;
    wire window_complete = (cycle_count == CYCLE_2);
    wire exactly_two_ones = (w_history == 3'b011 || 
                            w_history == 3'b101 || 
                            w_history == 3'b110);

    // Output assignment (combinational)
    assign z = (state == B) && window_complete && exactly_two_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= CYCLE_0;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        // Initialize first window with current w
                        w_history <= {2'b00, w};
                        cycle_count <= CYCLE_1;
                    end
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};
                    
                    // Update cycle counter
                    if (window_complete) begin
                        cycle_count <= CYCLE_0;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
            endcase
        end
    end

endmodule