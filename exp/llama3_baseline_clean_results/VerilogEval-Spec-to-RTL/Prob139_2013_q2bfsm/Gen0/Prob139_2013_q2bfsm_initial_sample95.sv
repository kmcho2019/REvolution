module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

localparam A = 4'd0, // Initial state
           B = 4'd1, // State after reset de-assertion
           C = 4'd2, // Monitoring x for sequence
           D = 4'd3, // g = 1, monitoring y
           E = 4'd4, // g = 1 permanently
           F = 4'd5; // g = 0 permanently

reg [3:0] state, next_state;
reg [1:0] x_sequence, next_x_sequence;
reg [1:0] y_count, next_y_count;
reg f_reg, g_reg;

always @(*) begin
    next_state = state;
    next_x_sequence = x_sequence;
    next_y_count = y_count;
    
    case(state)
        A: if (~resetn) begin
               next_state = A;
           end else begin
               next_state = B;
           end
        B: begin
               next_state = C;
               f_reg = 0;
           end
        C: begin
               if (x_sequence == 2'b01) begin // 1, 0 sequence detected
                   if (x) begin
                       next_state = D;
                       g_reg = 1;
                       next_x_sequence = 0;
                   end else begin
                       next_x_sequence = 0;
                   end
               end else begin
                   if (x) begin
                       next_x_sequence = next_x_sequence + 1;
                   end else if (x_sequence == 1) begin
                       next_x_sequence = 1;
                   end
               end
           end
        D: begin
               if (y || y_count == 2) begin
                   if (y) begin
                       next_state = E;
                   end else begin
                       next_state = F;
                   end
                   next_y_count = 0;
               end else begin
                   next_y_count = y_count + 1;
               end
           end
        E: begin
               g_reg = 1;
           end
        F: begin
               g_reg = 0;
           end
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f_reg <= 0;
        g_reg <= 0;
        x_sequence <= 0;
        y_count <= 0;
    end else begin
        state <= next_state;
        if (state == B) begin
            f_reg <= 1;
        end else begin
            f_reg <= 0;
        end
        g <= g_reg;
        x_sequence <= next_x_sequence;
        y_count <= next_y_count;
    end
end

assign f = f_reg;

endmodule