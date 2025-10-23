module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam IDLE         = 2'b00;
localparam SEQUENCE     = 2'b01;
localparam FINAL        = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

// Sequence detection shift register
reg [2:0] x_shift;
wire sequence_detected = (x_shift == 3'b101);

// Timer for y monitoring
reg [1:0] timer;

// Temporary register for one-cycle f pulse
reg f_pulse;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_shift <= 3'b0;
        timer <= 2'b0;
        f <= 1'b0;
        g <= 1'b0;
        f_pulse <= 1'b0;
    end else begin
        // Update shift register
        x_shift <= {x_shift[1:0], x};
        
        // State transition
        state <= next_state;
        
        // Output logic
        case (state)
            IDLE: begin
                f <= f_pulse;
                g <= 1'b0;
                timer <= 2'b0;
                f_pulse <= 1'b0; // Clear pulse after one cycle
            end
            
            SEQUENCE: begin
                f <= 1'b0;
                if (sequence_detected) begin
                    g <= 1'b1;
                    timer <= 2'b0;
                end
                
                // Increment timer when g=1
                if (g) begin
                    timer <= timer + 1'b1;
                end
            end
            
            FINAL: begin
                // Maintain permanent outputs
                f <= 1'b0;
                // g remains at its current value
            end
        endcase
        
        // Generate one-cycle f pulse after reset
        if (state == IDLE && next_state == SEQUENCE) begin
            f_pulse <= 1'b1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = SEQUENCE;
        end
        
        SEQUENCE: begin
            if (g) begin
                // Move to FINAL if y=1 or timer expires
                if (y || timer == 2'd2) begin
                    next_state = FINAL;
                end else begin
                    next_state = SEQUENCE;
                end
            end else begin
                next_state = SEQUENCE;
            end
        end
        
        FINAL: begin
            next_state = FINAL; // Stay until reset
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule