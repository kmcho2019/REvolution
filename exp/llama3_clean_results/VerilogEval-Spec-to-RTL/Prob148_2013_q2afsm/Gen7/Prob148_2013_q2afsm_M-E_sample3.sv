module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// Priority encoder
wire [1:0] priority_encoder_out;
priority_encoder priority_encoder_inst(
    .r(r),
    .out(priority_encoder_out)
);

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b00:  
            if (priority_encoder_out == 2'b01) begin
                next_state = 2'b01;  
            end else if (priority_encoder_out == 2'b10) begin
                next_state = 2'b10;  
            end else if (priority_encoder_out == 2'b11) begin
                next_state = 2'b11;  
            end else begin
                next_state = 2'b00;  
            end
        2'b01:  
            next_state = r[0] ? 2'b01 : 2'b00;
        2'b10:  
            next_state = r[1] ? 2'b10 : 2'b00;
        2'b11:  
            next_state = r[2] ? 2'b11 : 2'b00;
        default:
            next_state = 2'b00;  
    endcase
end

assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = (current_state == 2'b11);

endmodule

module priority_encoder(
    input  [2:0] r,
    output [1:0] out
);

always @(*) begin
    if (r[0]) begin
        out = 2'b01;
    end else if (r[1]) begin
        out = 2'b10;
    end else if (r[2]) begin
        out = 2'b11;
    end else begin
        out = 2'b00;
    end
end

endmodule