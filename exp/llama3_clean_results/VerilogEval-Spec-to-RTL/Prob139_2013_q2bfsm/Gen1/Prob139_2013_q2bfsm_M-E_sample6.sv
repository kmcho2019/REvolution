module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] x_count; // x sequence counter
reg [1:0] y_count; // y timer
reg x_detected; // flag to indicate x sequence detection
reg f_out; // output f
reg g_out; // output g

// Initialize the outputs
assign f = f_out;
assign g = g_out;

// x sequence detector
always @(posedge clk) begin
    if (!resetn) begin
        x_count <= 0;
        x_detected <= 0;
    end else if (x_detected) begin
        x_count <= 0;
    end else begin
        case (x_count)
            2'b00: begin
                if (x) begin
                    x_count <= 2'b01;
                end else begin
                    x_count <= 2'b00;
                end
            end
            2'b01: begin
                if (!x) begin
                    x_count <= 2'b10;
                end else begin
                    x_count <= 2'b00;
                end
            end
            2'b10: begin
                if (x) begin
                    x_detected <= 1;
                    x_count <= 0;
                end else begin
                    x_count <= 2'b00;
                end
            end
        endcase
    end
end

// y timer
always @(posedge clk) begin
    if (!resetn ||!x_detected) begin
        y_count <= 0;
    end else if (y) begin
        y_count <= 0;
    end else begin
        y_count <= y_count + 1;
    end
end

// output f
always @(posedge clk) begin
    if (!resetn) begin
        f_out <= 0;
    end else if (!x_detected &&!f_out) begin
        f_out <= 1;
    end else if (x_detected) begin
        f_out <= 0;
    end else begin
        f_out <= 0;
    end
end

// output g
always @(posedge clk) begin
    if (!resetn) begin
        g_out <= 0;
    end else if (x_detected &&!g_out) begin
        if (y || y_count < 2) begin
            g_out <= 1;
        end else begin
            g_out <= 0;
        end
    end else begin
        g_out <= g_out;
    end
end

endmodule