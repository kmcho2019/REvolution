module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_count; // x sequence counter
reg [1:0] y_count; // y timer
reg x_detected; // flag to indicate x sequence detection
reg y_detected; // flag to indicate y detection

always @(posedge clk) begin
    if (!resetn) begin
        x_count <= 0;
        y_count <= 0;
        x_detected <= 0;
        y_detected <= 0;
        f <= 0;
        g <= 0;
    end else begin
        // x sequence detection
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

        // y detection and timer
        if (x_detected &&!y_detected) begin
            if (y) begin
                y_detected <= 1;
                y_count <= 0;
            end else begin
                y_count <= y_count + 1;
            end
        end

        // output f
        if (!x_detected &&!f) begin
            f <= 1;
        end else begin
            f <= 0;
        end

        // output g
        if (x_detected && y_detected) begin
            g <= 1;
        end else if (x_detected && y_count >= 2) begin
            g <= 0;
        end
    end
end

endmodule