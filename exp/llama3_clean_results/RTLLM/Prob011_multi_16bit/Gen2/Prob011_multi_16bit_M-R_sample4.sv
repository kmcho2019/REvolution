module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [4:0] state;
reg [4:0] next_state;
reg [31:0] yout_r;
reg [15:0] areg;
reg [15:0] breg;
reg done_r;

// State machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        0: begin
            if (start) begin
                next_state = 1;
            end else begin
                next_state = 0;
            end
        end
        1: begin
            next_state = 2;
        end
        2: begin
            if (areg[0]) begin
                yout_r = yout_r + (breg << (state - 1));
            end
            if (state < 16) begin
                next_state = state + 1;
            end else begin
                next_state = 17;
            end
        end
        17: begin
            next_state = 0;
        end
        default: begin
            next_state = 0;
        end
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= 0;
        areg <= 0;
        breg <= 0;
        done_r <= 0;
    end else if (state == 1) begin
        areg <= ain;
        breg <= bin;
        yout_r <= 0;
    end else if (state == 17) begin
        done_r <= 1;
    end else if (state == 0 &&!start) begin
        done_r <= 0;
    end
end

// Assign outputs
assign yout = yout_r;
assign done = done_r;

endmodule