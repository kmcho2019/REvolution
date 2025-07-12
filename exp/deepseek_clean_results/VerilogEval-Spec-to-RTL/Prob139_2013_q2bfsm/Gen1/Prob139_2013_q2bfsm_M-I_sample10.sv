module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    localparam A = 2'b00;  // Initial/reset state
    localparam B = 2'b01;  // f=1 pulse state
    localparam C = 2'b10;  // Monitoring x for 1-0-1 sequence
    localparam D = 2'b11;  // Monitoring y after sequence detected

    reg [1:0] state, next_state;
    reg [1:0] x_seq;       // Shift register for x sequence detection
    reg y_timeout;         // Flag for y detection timeout

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_seq <= 2'b00;
            y_timeout <= 0;
            f <= 0;
            g <= 0;
        end else begin
            state <= next_state;
            
            // Shift register for x sequence detection
            x_seq <= {x_seq[0], x};
            
            // y timeout counter (1-bit for 2 cycles)
            if (state == D) begin
                y_timeout <= y_timeout + !y;
            end else begin
                y_timeout <= 0;
            end
            
            // Output logic
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                end
                B: begin
                    f <= 1;
                    g <= 0;
                end
                C: begin
                    f <= 0;
                    g <= 0;
                end
                D: begin
                    f <= 0;
                    g <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: begin
                if (x_seq == 2'b10 && x == 1'b1) begin  // Detected 1-0-1
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end
            D: begin
                if (y) begin
                    next_state = D;  // Stay permanently with g=1
                end else if (y_timeout) begin
                    next_state = D;  // Stay permanently with g=0
                end else begin
                    next_state = D;  // Keep monitoring
                end
            end
            default: next_state = A;
        endcase
    end

    // Permanent g behavior
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 0;
        end else if (state == D && y_timeout) begin
            g <= 0;  // Permanent g=0 if timeout
        end
        // g=1 is maintained by the state D output logic
    end

endmodule