module TopModule (
    output out
);
    // Output defaults to wire; assign constant 0 via continuous assignment without explicit wire declaration
    assign out = 1'b0;
endmodule