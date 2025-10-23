module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;
    reg [2:0] q;

    // Define an enumeration of states for the FSM
    localparam IDLE = 2'b00;
    localparam COUNT = 2'b01;

    reg [1:0] state;
    reg [2:0] counter;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (!a) begin
                    // Transition to COUNT state when 'a' becomes 0
                    state <= COUNT;
                    q <= 4;
                end else begin
                    // Stay in IDLE state when 'a' is 1
                    state <= IDLE;
                    q <= 4;
                end
            end
            COUNT: begin
                if (counter == 7) begin
                    // Reset counter when it reaches 7
                    counter <= 0;
                    q <= 0;
                    state <= COUNT;
                end else begin
                    // Increment counter
                    counter <= counter + 1;
                    q <= counter;
                    state <= COUNT;
                end
            end
            default: begin
                // Default state
                state <= IDLE;
                q <= 4;
            end
        endcase
    end

    // Initialize state and counter at reset
    initial begin
        state <= IDLE;
        counter <= 0;
        q <= 4;
    end
endmodule