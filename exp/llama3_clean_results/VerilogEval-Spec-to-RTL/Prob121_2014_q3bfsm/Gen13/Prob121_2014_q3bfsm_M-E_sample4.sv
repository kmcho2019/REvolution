module State000(
    input clk,
    input reset,
    input x,
    input token_in,
    output reg token_out
);

reg token_out_reg;

always @(posedge clk) begin
    if (reset) begin
        token_out_reg <= 1'b0;
    end else if (token_in) begin
        if (x) begin
            token_out_reg <= 1'b1;
        end else begin
            token_out_reg <= 1'b0;
        end
    end else begin
        token_out_reg <= 1'b0;
    end
end

assign token_out = token_out_reg;

endmodule

module State001(
    input clk,
    input reset,
    input x,
    input token_in,
    output reg token_out
);

reg token_out_reg;

always @(posedge clk) begin
    if (reset) begin
        token_out_reg <= 1'b0;
    end else if (token_in) begin
        if (x) begin
            token_out_reg <= 1'b1;
        end else begin
            token_out_reg <= 1'b1;
        end
    end else begin
        token_out_reg <= 1'b0;
    end
end

assign token_out = token_out_reg;

endmodule

module State010(
    input clk,
    input reset,
    input x,
    input token_in,
    output reg token_out
);

reg token_out_reg;

always @(posedge clk) begin
    if (reset) begin
        token_out_reg <= 1'b0;
    end else if (token_in) begin
        if (x) begin
            token_out_reg <= 1'b0;
        end else begin
            token_out_reg <= 1'b1;
        end
    end else begin
        token_out_reg <= 1'b0;
    end
end

assign token_out = token_out_reg;

endmodule

module State011(
    input clk,
    input reset,
    input x,
    input token_in,
    output reg token_out
);

reg token_out_reg;

always @(posedge clk) begin
    if (reset) begin
        token_out_reg <= 1'b0;
    end else if (token_in) begin
        if (x) begin
            token_out_reg <= 1'b1;
        end else begin
            token_out_reg <= 1'b0;
        end
    end else begin
        token_out_reg <= 1'b0;
    end
end

assign token_out = token_out_reg;

endmodule

module State100(
    input clk,
    input reset,
    input x,
    input token_in,
    output reg token_out
);

reg token_out_reg;

always @(posedge clk) begin
    if (reset) begin
        token_out_reg <= 1'b0;
    end else if (token_in) begin
        if (x) begin
            token_out_reg <= 1'b1;
        end else begin
            token_out_reg <= 1'b0;
        end
    end else begin
        token_out_reg <= 1'b0;
    end
end

assign token_out = token_out_reg;

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [4:0] token;

State000 state000(
    .clk(clk),
    .reset(reset),
    .x(x),
    .token_in(token[0]),
    .token_out(token[1])
);

State001 state001(
    .clk(clk),
    .reset(reset),
    .x(x),
    .token_in(token[1]),
    .token_out(token[2])
);

State010 state010(
    .clk(clk),
    .reset(reset),
    .x(x),
    .token_in(token[2]),
    .token_out(token[3])
);

State011 state011(
    .clk(clk),
    .reset(reset),
    .x(x),
    .token_in(token[3]),
    .token_out(token[4])
);

State100 state100(
    .clk(clk),
    .reset(reset),
    .x(x),
    .token_in(token[4]),
    .token_out(token[0])
);

always @(posedge clk) begin
    if (reset) begin
        token <= 5'b10000;
    end else begin
        token <= {token[4], token[3], token[2], token[1], token[0]};
    end
end

always @(posedge clk) begin
    if (reset) begin
        z <= 1'b0;
    end else if (token[3] || token[4]) begin
        z <= 1'b1;
    end else begin
        z <= 1'b0;
    end
end

endmodule