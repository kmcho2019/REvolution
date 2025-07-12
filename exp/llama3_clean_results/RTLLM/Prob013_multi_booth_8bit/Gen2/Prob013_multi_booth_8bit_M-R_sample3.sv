module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output reg [15:0] p, 
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr;
reg [1:0] state;

// Reset logic
always @(posedge reset) begin
    multiplier <= {{8{a[7]}}, a};
    multiplicand <= {{8{b[7]}}, b};
    p <= 0;
    ctr <= 0;
    rdy <= 0;
    state <= 0; // IDLE state
end

// State machine and counter logic
always @(posedge clk) begin
    if (!reset) begin
        case (state)
            0: begin // IDLE state
                state <= 1; // RUNNING state
            end
            1: begin // RUNNING state
                if (ctr < 16) begin
                    multiplicand <= multiplicand << 1;
                    if (multiplier[ctr] == 1) begin
                        p <= p + multiplicand;
                    end
                    ctr <= ctr + 1;
                    if (ctr == 16) begin
                        rdy <= 1;
                        state <= 0; // IDLE state
                    end
                end
            end
        endcase
    end
end

// Assign statements for combinational logic
assign p = (state == 1 && ctr < 16) ? p + multiplicand : p;
assign rdy = (state == 1 && ctr == 16) ? 1 : 0;

endmodule