module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;
    // Counter for 3-cycle windows
    reg [1:0] cycle_count;
    // Internal signal for window evaluation
    wire window_complete;
    wire [1:0] ones_count;

    // Combinational outputs
    assign window_complete = (state == B) && (cycle_count == 2'b10);
    assign ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = window_complete && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            cycle_count <= 2'b00;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= {2'b00, w};
                        cycle_count <= 2'b01;
                    end
                end
                B: begin
                    // Update shift register
                    w_history <= {w_history[1:0], w};
                    
                    // Update cycle counter
                    if (window_complete) begin
                        cycle_count <= 2'b00;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
            endcase
        end
    end

endmodule