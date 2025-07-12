module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// LFSR taps for maximal length 16-bit sequence
parameter [15:0] LFSR_TAPS = 16'hD008;

// Predictive carry signals
wire [3:0] carry_pred;
wire [3:0] borrow_pred;

// LFSR portion (bits 3:0)
wire [3:0] lfsr_next = up_down ? 
              {count[2:0], count[3]^count[0]} : 
              {count[0]^count[3], count[3:1]};

// Carry prediction logic
assign carry_pred[0] = up_down & (&count[3:0]);
assign carry_pred[1] = up_down & (&count[7:0]);
assign carry_pred[2] = up_down & (&count[11:0]);
assign carry_pred[3] = up_down & (&count[15:0]);

assign borrow_pred[0] = ~up_down & (~|count[3:0]);
assign borrow_pred[1] = ~up_down & (~|count[7:0]);
assign borrow_pred[2] = ~up_down & (~|count[11:0]);
assign borrow_pred[3] = ~up_down & (~|count[15:0]);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        // Update LFSR portion
        count[3:0] <= lfsr_next;
        
        // Conditional updates for upper bits using carry prediction
        count[7:4] <= count[7:4] + {3'b0,carry_pred[0]} - {3'b0,borrow_pred[0]};
        count[11:8] <= count[11:8] + {3'b0,carry_pred[1]} - {3'b0,borrow_pred[1]};
        count[15:12] <= count[15:12] + {3'b0,carry_pred[2]} - {3'b0,borrow_pred[2]};
    end
end

endmodule